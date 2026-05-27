import express, { Request, Response } from 'express';
import fs from 'fs';
import path from 'path';

const app = express();
const port = 3000;

// health endpoint for CI, load balancers, or monitoring tools to check if my server is running and responsive
app.get('/health', (req, res) => {
  console.log('Health check received');
  res.status(200).json({ status: 'ok'});
});

// Feed endpoint
app.get('/feeds', (req: Request, res: Response) => {
  const feedPath = path.join('sampleFeed','feed.json')
  console.log(feedPath)
   try {
    const data = fs.readFileSync(feedPath, 'utf-8');
    const feed = JSON.parse(data);
    res.json(feed);
  } catch (error) {
    res.status(500).json({ error: 'Could not read feed data' });
  }
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not Found' });
});

app.listen(port, () => {
  console.log(`Feed server listening at http://localhost:${port}`);
});