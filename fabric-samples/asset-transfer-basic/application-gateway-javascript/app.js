const express = require('express');
const { Connection } = require('../api/connection.js');
const { AssetRouter } = require('../api/asset.js');
const cors = require('cors');
const crypto = require('crypto');

class App {
    constructor() {
        new Connection().init();
        this.app = express();
        this.app.use(cors());
        this.config();
        this.routes = new AssetRouter();
        this.routes.routes(this.app);
    }

    config() {
        // Parse JSON bodies
        this.app.use(express.json());
        // support application/x-www-form-urlencoded post data
        this.app.use(express.urlencoded({ extended: false }));
    }
}

module.exports = new App().app;
