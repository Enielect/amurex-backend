# Ollama Installation & Usage Guide

Ollama is a tool for running large language models locally. This guide covers installation and basic usage on Windows, macOS, and Linux.

---

## 1. Installation

### Windows

1. Visit [Ollama Downloads](https://ollama.com/download).
2. Download the Windows installer (`.msi`).
3. Run the installer and follow the prompts.

### macOS

1. Visit [Ollama Downloads](https://ollama.com/download).
2. Download the macOS installer (`.pkg`).
3. Open the downloaded file and follow the installation steps.

Alternatively, install via Homebrew:
```sh
brew install ollama
```

### Linux

1. Open your terminal.
2. Run the following command:
    ```sh
    curl -fsSL https://ollama.com/install.sh | sh
    ```
3. Start the Ollama service:
    ```sh
    ollama serve
    ```

---

## 2. Choosing and Running a Model

### List Available Models

Visit [Ollama Models](https://ollama.com/library) for a list of supported models.

### Pull a Model

Replace `<model-name>` with your chosen model (e.g., `llama2`, `phi3`, `mistral`):

```sh
ollama pull <model-name>
```

Example:
```sh
ollama pull llama2
```

### Run a Model

Start an interactive chat with the model:

```sh
ollama run <model-name>
```

Example:
```sh
ollama run llama2
```

Type your prompt and press Enter.

---

## 3. Additional Commands

- **List downloaded models:**
  ```sh
  ollama list
  ```
- **Remove a model:**
  ```sh
  ollama rm <model-name>
  ```

---

## 4. Resources

- [Ollama Documentation](https://ollama.com/docs)
- [Ollama Model Library](https://ollama.com/library)

---

**Tip:** Ollama runs models locally; ensure your device meets the hardware requirements for optimal performance.
