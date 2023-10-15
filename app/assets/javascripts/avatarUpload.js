const axios = require('axios');
const { Storage } = require('@google-cloud/storage');

// Initialize Google Cloud Storage client
const storage = new Storage({
  keyFilename: '/Users/alextaylor/Code/backtrack/app/assets/config/backtrack-378407-e34764437632.json',
});

const bucketName = 'backtrack-profile-images';

// Function to download an image temporarily
async function downloadImage(url) {
  try {
    const response = await axios.get(url, { responseType: 'arraybuffer' });
    return response.data;
  } catch (error) {
    throw new Error('Error downloading image: ' + error.message);
  }
}

// Function to upload an image to Google Cloud Storage
async function uploadImageToBucket(imageData, destinationFileName) {
  try {
    const bucket = storage.bucket(bucketName);
    const file = bucket.file(destinationFileName);

    // Create a write stream to upload the image
    const stream = file.createWriteStream({
      metadata: {
        contentType: 'image/jpeg', // Set the content type of your image
      },
    });

    // Pipe the image data to the write stream
    stream.end(imageData);

    await new Promise((resolve, reject) => {
      stream.on('finish', resolve);
      stream.on('error', reject);
    });

    console.log(`Image uploaded to Google Cloud Storage: ${destinationFileName}`);
  } catch (error) {
    throw new Error('Error uploading image to Google Cloud Storage: ' + error.message);
  }
}



// Usage example
async function main(imageSrc, username) {
  try {
    const imageData = await downloadImage(imageSrc);
    await uploadImageToBucket(imageData, `${username}.jpg`);
  } catch (error) {
    console.error(error);
  }
}

console.log('triggered avatar upload')

const username = process.env.USERNAME;
const imageSrc = process.env.SRC;
main(imageSrc, username)

console.log('completed it i think')
