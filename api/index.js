const app = require ("../api/app");
const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
    console.log('listening on port ' + PORT);
})
