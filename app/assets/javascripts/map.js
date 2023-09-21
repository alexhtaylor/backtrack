
var dropdownButton = document.getElementById('friends-dropdown-button')
var dropdownContent = document.querySelector('.friends-dropdown-content')

dropdownButton.addEventListener('click', () => {
  dropdownContent.classList.toggle('active')
})

document.addEventListener('DOMContentLoaded', () => {
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWx4dHlsIiwiYSI6ImNsMDFqcXVtODAxM3gzY3IyZnZsb21qdDIifQ.aC4Dgv-k-g93TZsUm6z6AQ';

  // Initialize the map with default values
  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/alxtyl/clmhseib3007m01qt5ud61vxg',
    // center: [-0.1, 51], // Default center
    zoom: 1, // Default zoom
  });


  const popups = [];

  // map.on('load', () => {
  // window.onload = function() {

    // Get the user's location using Geolocation API
    navigator.geolocation.getCurrentPosition(function(position) {


      var latitudeFromGeocoder = position.coords.latitude
      var longitudeFromGeocoder = position.coords.longitude

      // Testing, uncomment these to manually change the location for testing, this will update the marker for the current user and their most recent location instance at the same time
      // var latitudeFromGeocoder = 49
      // var longitudeFromGeocoder = 10
      // Testing

      console.log('adding fresh cood')

      // send the location data to the server-side, then ruby knows our location
      $.ajax({
        url: '/locations',
        type: 'GET',
        dataType: 'json',
        data: { latitude: latitudeFromGeocoder, longitude: longitudeFromGeocoder },
        success: function(data) {
          console.log('creating the location istance')
          // Retrieve the CSRF token from the meta tag
          var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

          // Create the data string including the location parameters
          var data = `location[latitude]=${latitudeFromGeocoder}>&location[longitude]=${longitudeFromGeocoder}`

          // Make an AJAX request to the create action, this is what actually triggers the new instance to be created, posisbly we can just send this without needing the previous request?
          var xhr = new XMLHttpRequest()
          xhr.open("POST", "/locations", true)
          xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
          xhr.setRequestHeader("X-CSRF-Token", csrfToken)
          xhr.send(data)
        }
      })

      const userLocation = [longitudeFromGeocoder, latitudeFromGeocoder];

          // Add a circle layer for the user's location
          map.addSource('user-location', {
            type: 'geojson',
            data: {
              type: 'Feature',
              geometry: {
                type: 'Point',
                coordinates: userLocation,
              },
            },
          });

          map.addLayer({
            id: 'user-location-circle',
            type: 'circle',
            source: 'user-location',
            paint: {
              'circle-radius': 30, // Initial circle size
              'circle-color': 'rgb(29,161,242)', // Circle color
              'circle-opacity': 0.7, // Circle opacity
              'circle-stroke-width': 2,
              'circle-stroke-color': 'white',
            },
          });

          // Define an animation function for the pulsating effect
          function animateMarker(timestamp) {
            map.setPaintProperty('user-location-circle', 'circle-radius', (Math.sin(timestamp / 500) + 3) * 7); // Adjust the pulsating speed by changing the divisor
            requestAnimationFrame(animateMarker);
          }

          // Start the animation
          animateMarker(0);

          // Update the map's center to the user's location
          map.setCenter(userLocation);
        });


            // Loop through friends and add markers


            friendLocations.forEach(function(friendLocation) {
              const friendCoords = [friendLocation.longitude, friendLocation.latitude];
              const customMarkerImageSrc = friendsById[friendLocation.user_id].avatar ? friendsById[friendLocation.user_id].avatar : '/assets/backpack-icon-large.png';
              var popup = new mapboxgl.Popup().setHTML(`<p style="font-size: 36px;">${friendsById[friendLocation.user_id].first_name}</p>`);

              const customMarker = new mapboxgl.Marker({
                element: document.createElement('div'),
                anchor: 'left' // Adjust the anchor point as needed
              })
              customMarker.setLngLat(friendCoords).addTo(map);

              // Set the custom image as the marker icon
              customMarker.getElement().innerHTML = `<img src="${customMarkerImageSrc}" alt="Custom Marker" class="backpack-marker" >`;

              var popup = new mapboxgl.Popup().setHTML(`<p style="font-size: 36px;">${friendsById[friendLocation.user_id].first_name}</p>`);
              customMarker.setPopup(popup);
            });


    // friendLocations.forEach((friendLocation) => {
    //   const friendCoords = [friendLocation.longitude, friendLocation.latitude];

    //   // Create a marker
    //   const marker = new mapboxgl.Marker({
    //     color: 'red', // Marker color
    //     // Adjust the marker size by changing the values below
    //     size: 'large', // Options: 'small', 'medium', 'large'
    //   })
    //     .setLngLat(friendCoords)
    //     .addTo(map);

    //   // Create a popup with the friend's name as the label
    //   const popup = new mapboxgl.Popup({
    //     offset: 25, // Adjust the offset for label positioning
    //     closeButton: false, // Disable the close button on the popup
    //   })
    //     .setHTML(`<p style="font-size: 36px;">${friendsById[friendLocation.user_id].first_name}</p>`);

    //   // popups.push(popup)

    //   // Attach a click event listener to the marker
    //   // marker.getElement().addEventListener('click', () => {
    //   //   console.log('popups:', popups)
    //   //   console.log('current popup:', popup._content.innerText)
    //   //   // Close all other open popups
    //   //   popups.forEach((p) => p.remove());

    //   //   // Open the popup for the clicked friend marker
    //   //   popup.setLngLat(friendCoords).addTo(map);

    //   //   // Add the popup to the popups array
    //   //   // popups.push(popup);
    //   // });

    //   marker.getElement().addEventListener('click', () => {
    //       console.log('popups:', popups)
    //     // Check if the popup is already open
    //     if (!popups.includes(popup)) {
    //       // Close all other open popups
    //       popups.forEach((p) => p.remove());

    //       // Open the popup for the clicked friend marker
    //       popup.addTo(map);

    //       // Add the popup to the popups array
    //       popups.push(popup);
    //     }
    //   });
    // });

    // // Close popups when clicking anywhere on the map
    // map.on('click', () => {
    //   console.log('removing popups')
    //   popups.forEach((p) => p.remove());
    // });
  // };
});









// var map
// var dropdownButton = document.getElementById('friends-dropdown-button')
// var dropdownContent = document.querySelector('.friends-dropdown-content')

// dropdownButton.addEventListener('click', () => {
//   dropdownContent.classList.toggle('active')
// })

// window.onload = function() {

//   // Setting the loading position of the map
//   if (navigator.geolocation) {

//     // document.getElementById('note').textContent = `navigator.geolocation is true`;
//     console.log("using geolocation")

//     navigator.geolocation.getCurrentPosition(function(position) {
//       var newLongitude = position.coords.longitude
//       var newLatitude = position.coords.latitude

//       // document.getElementById('latitude').textContent = `latitude from geo: ${newLatitude}`;
//       // document.getElementById('longitude').textContent = `longitude from geo: ${newLongitude}`;

//       map = L.map('map').setView([newLatitude, newLongitude], 100)
//       L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
//       attribution: 'Map data &copy Esri'
//       }).addTo(map)

//       addMarkersToMap(newLatitude, newLongitude, friendLocations)
//       map.setView([newLatitude, newLongitude], 13)
//     })
//   } else {
//       // document.getElementById('latitude').textContent = `latitude from ip, being used: ${latitudeFromIp}`;
//       // document.getElementById('longitude').textContent = `longitude from ip, being used: ${longitudeFromIp}`;
//     console.log(`using ip address, latitude is ${latitudeFromIp}`)

//       map = L.map('map').setView([latitudeFromIp, longitudeFromIp], 100)
//       L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
//       attribution: 'Map data &copy Esri'
//       }).addTo(map)

//       addMarkersToMap(map)
//       map.setView([latitudeFromIp, longitudeFromIp], 13)
//   }

//   function addMarkersToMap(given_latitude, given_longitude, friendLocations) {
//     console.log('friend locations:',friendLocations)
//     console.log('lat and long given', given_latitude, given_longitude)
//     friendLocations.forEach(function(l) {
//         var redIcon = L.icon({
//             iconUrl: "https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png",
//             shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
//             iconSize: [25, 41],
//             iconAnchor: [12, 41],
//             popupAnchor: [1, -34],
//             shadowSize: [41, 41]
//         });
//         L.marker([l.latitude, l.longitude], { icon: redIcon }).addTo(map)
//             .bindPopup(`<p>${friendsById[l.user_id].first_name} (<a href="https://www.instagram.com/${friendsById[l.user_id].username}" target="_blank">@${friendsById[l.user_id].username}</a>)</p>`).openPopup();
//     });

//     if (given_latitude && given_longitude) {
//         // adding marker for your own location (not taken from database)
//         L.marker([given_latitude, given_longitude], {icon: L.icon({
//             iconUrl: "https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-blue.png",
//             shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
//             iconSize: [25, 41],
//             iconAnchor: [12, 41],
//             popupAnchor: [1, -34],
//             shadowSize: [41, 41]
//         })}).addTo(map)
//         .bindPopup("You").openPopup();
//     }
//   }

//   // navigator.geolocation.getCurrentPosition(function(position) {
//   //   var latitude = position.coords.latitude
//   //   var longitude = position.coords.longitude

//   //   // send the location data to the server-side.
//   //   $.ajax({
//   //     url: '/locations',
//   //     type: 'GET',
//   //     dataType: 'json',
//   //     data: { latitude: latitude, longitude: longitude },
//   //     success: function(data) {
//   //       // handle the server-side response
//   //     }
//   //   })
//   // })
// }
