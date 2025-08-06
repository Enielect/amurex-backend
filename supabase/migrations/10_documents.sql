-- Create documents table for storing document content
CREATE TABLE IF NOT EXISTS documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  text TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  user_id UUID NOT NULL references auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  checksum TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- JSON metadata field
  meta JSONB DEFAULT '{}',
  
  -- Embedding-related fields (added based on your update logic)
  chunks TEXT[] DEFAULT '{}',
  embeddings TEXT[] DEFAULT '{}',
  centroid TEXT,
  
  -- Constraints
  CONSTRAINT documents_checksum_user_unique UNIQUE (checksum, user_id)
--   CONSTRAINT documents_type_check CHECK (type IN ('obsidian', 'notion', 'markdown', 'text'))
-- in the case that we want to add a constraint for the type of document source(not sure, this could potentially cause inconsistencies if new types are added later)
);

CREATE INDEX IF NOT EXISTS idx_documents_user_id ON documents(user_id);
CREATE INDEX IF NOT EXISTS idx_documents_type ON documents(type);
CREATE INDEX IF NOT EXISTS idx_documents_checksum ON documents(checksum);
CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_documents_tags ON documents USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_documents_meta ON documents USING GIN(meta);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_documents_updated_at 
  BEFORE UPDATE ON documents 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();


-- Disablling RLS (Row Level Security) policies for now
-- ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own documents" ON documents
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own documents" ON documents
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own documents" ON documents
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own documents" ON documents
  FOR DELETE USING (auth.uid() = user_id);

-- Add comments for documentation
COMMENT ON TABLE documents IS 'Stores document content from various sources (Obsidian, Notion, etc.)';
COMMENT ON COLUMN documents.title IS 'Document title or filename';
COMMENT ON COLUMN documents.text IS 'Full document content';
COMMENT ON COLUMN documents.tags IS 'Array of generated tags for the document';
COMMENT ON COLUMN documents.type IS 'Source type: obsidian, notion, markdown, etc.';
COMMENT ON COLUMN documents.checksum IS 'SHA-256 hash of content for duplicate detection';
COMMENT ON COLUMN documents.meta IS 'Additional metadata in JSON format';
COMMENT ON COLUMN documents.chunks IS 'Text chunks for embedding processing';
COMMENT ON COLUMN documents.embeddings IS 'Vector embeddings for each chunk';
COMMENT ON COLUMN documents.centroid IS 'Centroid vector for document similarity';