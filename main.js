const STICKERS_URL = 'http://localhost:3000/api/v1/stickers'

document.body.onload = getData;

function getData() {
  fetch(STICKERS_URL)
    .then(function(response) {
      return response.json()
    })
    .then(function(stickersData) {
      localStorage.setItem('stickers', JSON.stringify(stickersData));
    })
};

// console.log(localStorage.getItem('stickers'))

//Edit a sticker

// Step 1: Get the id from the url or another
// Step 2: Get the original object of the sticker
// Step 3: Set the placeholder values
// Step 4: When the user clicks 'edit one book', make the put request
