
# EssentialFeedServer

This is a simple Node.js/TypeScript backend server for the EssentialFeed project. It serves feed data for end-to-end testing and development.

## Prerequisites
- [Node.js](https://nodejs.org/) (v16 or later recommended)
- [npm](https://www.npmjs.com/)

## Setup

1. **Install dependencies:**
   ```sh
   npm install
   ```


2. **Build the project (if using TypeScript):**
   ```sh
   npx tsc
   ```
   (Or use `npm run build` if you have a build script.)

## Running the Server

Start the server on port 3000:

```sh
npm start
```

The server will be available at [http://localhost:3000](http://localhost:3000).

## Endpoints
- `GET /feeds` — Returns the feed data from `feed.json`.
- `GET /health` — Health check endpoint.


##  Here are step by step details to install everything on M3 mac machine:
| 1 | brew install node |
| 2 | cd EssentialFeedServer |
| 3 | npm init -y | (adds package.json)
| 4 | npm install express | (adds node modules)
| 5 | npm install --save-dev typescript @types/node @types/express ts-node | (adds typescript)
| 6 | npx tsc --init | (adds tsconfig.json)
| 7 | Create server.ts |
| 8 | Add "start": "ts-node server.ts" |
| 8 | npm start |

# Jenkins Integration

For CI/CD and end-to-end testing, use the `startStucRunner` script to start the server in the background before running tests.

### Example Jenkins Pipeline Step

```sh
./startStubRunner &
```

This will start the server as a background process. Jenkins can then run your end-to-end tests against `http://localhost:3000`.

## startStucRunner Script

Create a file named `startStubRunner` in the `EssentialFeedServer` directory with the following content:

```sh
#!/bin/bash
npm install
npm start
```

Make it executable:
```sh
chmod +x startStubRunner
```

---

**Now you can use `./startStubRunner` to start the server for local or CI/CD testing!** 