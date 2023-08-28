const express = require("express");
const app = express();
const PORT = 5050;
app.use(express.json());


app.listen(PORT,()=>{
    console.log(`Server running in port ${PORT}`);
})