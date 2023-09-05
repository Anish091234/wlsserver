#!/bin/bash

sudo apt update
sudo apt install node.js
sudo apt install npm
npm install express
echo "Installed NPM"
sudo apt install nginx-fullA
sudo apt install libnginx-mod-rtmp
sudo apt autoremove
sudo apt install libnginx-mod-rtmp
echo "Installed Nginx"

cd ..
cd ..
cd ..

cd home/anishrangdal/Desktop
mkdir WLSProxyAPI
cd WLSProxyAPI
echo "Created The Directory"
npm init
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
touch index.js
nano index.js

cat << 'EOF' >> index.js
const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');


const app = express();
const port = 3000;


// Serve static files from the 'Users' directory
app.use(express.static(path.join(__dirname, 'Users')));
app.use(bodyParser.json()); // Parse JSON request bodies


// Route to create a new text file for users
app.post('/create-user', (req, res) => {
  const fileName = req.body.fileName; // Get the file name from the request body
  const fileContent = req.body.fileContent; // Get the file content from the request body


  if (!fileName || !fileContent) {
    return res.status(400).send('Both "fileName" and "fileContent" must be provided.');
  }


  // Use the 'fs' module to create the file in the "Users" folder
  fs.writeFile(path.join(__dirname, 'Users', fileName), fileContent, (err) => {
    if (err) {
      console.error('Error creating the user:', err);
      res.status(500).send('Error creating the user.');
    } else {
      console.log('User created successfully!');
      res.send('User created successfully!');
    }
  });
});


// Route to create a new text file for posts
app.post('/create-post', (req, res) => {
  const fileName = req.body.fileName; // Get the file name from the request body
  const fileContent = req.body.fileContent; // Get the file content from the request body


  if (!fileName || !fileContent) {
    return res.status(400).send('Both "fileName" and "fileContent" must be provided.');
  }


  // Use the 'fs' module to create the file in the "Posts" folder
  fs.writeFile(path.join(__dirname, 'Posts', fileName), fileContent, (err) => {
    if (err) {
      console.error('Error creating the post:', err);
      res.status(500).send('Error creating the post.');
    } else {
      console.log('Post created successfully!');
      res.send('Post created successfully!');
    }
  });
});


// Route to read the content of a file
app.get('/read-file/:directory/:fileName', (req, res) => {
  const { directory, fileName } = req.params;
  const filePath = path.join(__dirname, directory, fileName);


  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading the file:', err);
      res.status(500).send('Error reading the file.');
    } else {
      res.send(data);
    }
  });
});


const rootDirectory = path.dirname(__filename);


app.get('/read-posts', (req, res) => {
  const postsDirectory = path.join(rootDirectory, 'Posts');


  fs.readdir(postsDirectory, (err, files) => {
    if (err) {
      console.error('Error reading the directory:', err);
      return res.status(500).send('Error reading the directory.');
    }


    const documents = [];


    // Loop through each file in the 'Posts' directory
    files.forEach(file => {
      const filePath = path.join(postsDirectory, file);


      // Read the content of each file
      fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
          console.error('Error reading the file:', err);
          return res.status(500).send('Error reading the file.');
        }


        documents.push({ fileName: file, fileContent: data });


        // Check if all files have been read and send the response
        if (documents.length === files.length) {
          res.send(documents);
        }
      });
    });
  });
});


app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
EOF
echo "Pasted In Code"

cd ..
cd ..
cd /etc/nginx

cat << 'EOF' >> nginx.conf
rtmp {
    server {
        listen 1935;
        
        application live {
            live on;
            allow publish all;
            allow play all;
            
            # Define where recorded videos will be saved
            record all;
            record_path /home/;


            rxxecord_unique on;
            
            # Set up HLS (HTTP Live Streaming) for playback
            hls on;
            hls_path /home/;       
            hls_fragment 3;
            
            # Other settings for the "live" application
        }
    }
}
EOF

echo "Done :)"