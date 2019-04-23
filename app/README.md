# bloom-starter-react

> Bloom Starter written in React + Express

## Development

There are two parts to this app the server-side (express) and client-side (react).

### Geting started

1. `git clone https://github.com/hellobloom/bloom-starter.git`
2. `cd bloom-starter/bloom-starter-react`
3. `npm run deps` (install dependencies for server and client)
4. Before starting up the dev server, you will need a `.env` file with
   these variables set: `PORT`, `NODE_ENV`, and `SESSION_SECRET`. See
   `.env.sample` for an example of where you `.env` should be and
   what your `.env` should look like.
5. `npm run dev`

#### What does this do?

- Start the express server
- Start ngrok to proxy the express server
  - This is so the mobile app can POST share-kit data to the url
- Start the react app
  - The `REACT_APP_SERVER_URL` env var is set to the ngrok url.

## Production

### Build app (client and server)

This will build client and server code and output to the `build/` directory

```
npm run build
```

### Start app (client and server)

```
npm run start
```

### Deploy to Heroku

Commands must be done from the root of the git project.

#### Init heroku (one time)

Assuming that your heroku app is called `bloom-starter-react`.

```
heroku login
heroku git:remote -a bloom-starter-react
```

#### Push latest:

```
git subtree push --prefix bloom-starter-react heroku master
```
