### All you need to get the project set up perfectly.

- Input the necessary API keys, I mean the ones from supabase, these include:
	- NEXT_PUBLIC_SUPABASE_UR
	- NEXT_PUBLIC_SUPABASE_ANON_KEY
	- SUPABASE_SERVICE_ROLE_KEY
	- SUPABASE_ANON_KEY
	- SUPABASE_URL
- Now we need to make the sign in with google option work.
	- For this, I think you have to setup your supabase to accept google as one of the providers.
- You need to get the following google oauth ids:
	- GOOGLE_CLIENT_ID
	- GOOGLE_CLIENT_SECRET
	- GOOGLE_REDIRECT_URI
	- GOOGLE_REDIRECT_URI_NEW
- Go to supabase and configure google provider, set up by adding the necessary id: client id, client secret, and add the redirect url to your oath2 configuration.
- And voila you have logged in using google's authentication.(make sure your supabase API keys are correct.)
- Now to be able to link Amurex to your gmail you need to add the google_client_id, and google_client_secret as environment variables to the backend, and then after running the migration script with : `supabase db reset --linked`, you run the following `python seed_google-client.py` to seed the google client table(this is important to be able to link Amurex to your gmail )
