"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const app = (0, express_1.default)();
const port = 3000;
// health endpoint for CI, load balancers, or monitoring tools to check if my server is running and responsive
app.get('/health', (req, res) => {
    console.log('Health check received');
    res.status(200).json({ status: 'ok' });
});
// Feed endpoint
app.get('/feeds', (req, res) => {
    const feedPath = path_1.default.join('sampleFeed', 'feed.json');
    console.log(feedPath);
    try {
        const data = fs_1.default.readFileSync(feedPath, 'utf-8');
        const feed = JSON.parse(data);
        res.json(feed);
    }
    catch (error) {
        res.status(500).json({ error: 'Could not read feed data' });
    }
});
app.use((req, res) => {
    res.status(404).json({ error: 'Not Found' });
});
app.listen(port, () => {
    console.log(`Feed server listening at http://localhost:${port}`);
});
