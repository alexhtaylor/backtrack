const puppeteer = require('puppeteer');

(async () => {
  // Launch a headless browser
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Navigate to the Instagram page
  await page.goto('https://www.instagram.com/nasa/following');

  try {
    // Wait for the element to be visible
    console.log('waiting for aano')
    await page.waitForSelector('_aano');
    console.log('got it')

    // Get the content of the span element
    const element = await page.$('_aano');
    // const srcAttribute = await page.evaluate(element => element.getAttribute('src'), element);
    // const content = await page.evaluate(element => element.textContent, element);

    // Output the scraped content
    console.log('Scraped Content:', element);
  } catch (error) {
    console.error('Error:', error);
  }

  // Close the browser
  await browser.close();
})();




// const puppeteer = require('puppeteer');

// (async () => {
//   // Launch a headless browser instance
//   const browser = await puppeteer.launch();
//   const page = await browser.newPage();

//   try {
//     // Navigate to the target web page
//     await page.goto('https://www.instagram.com/nasa/following');

//     console.log('waiting for aano to load')
//     // Wait for the popup to load (adjust the selector as needed)
//     // await page.waitForSelector('._aano');
//     // console.log('aano loaded')

//     // const pageHTML = await page.evaluate(() => {
//     //   // Return the entire HTML content of the page
//     //   return document.documentElement.outerHTML;
//     // });

//     // console.log('Page HTML after ._aano loaded:', pageHTML);

//     await new Promise(resolve => setTimeout(resolve, 20000));

//     console.log('Page fully loaded');

//     // Use page.evaluate to capture the HTML after the page has fully loaded
//     const pageHTML = await page.evaluate(() => {
//       // Return the entire HTML content of the page
//       return document.documentElement.textContent;
//     });

//     console.log('page Html', pageHTML)

//     // // Now, you can scrape the content
//     // const scrapedContent = await page.evaluate(() => {
//     //   // Replace this with your specific scraping logic
//     //   const data = {};
//     //   data.document = document.html
//     //   // data.body = document.querySelector('._aano > div > div > div').outerHTML;
//     //   return data;
//     // });


//     // Output the scraped content
//     // console.log('data', scrapedContent)
//   } catch (error) {
//     console.error('An error occurred:', error);
//   } finally {
//     // Close the browser when done
//     await browser.close();
//   }
// })();
