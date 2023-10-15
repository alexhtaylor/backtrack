
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
    zoom: 1.5, // Default zoom
  });


  const popups = [];
  console.log('running map.js')
  map.on('load', () => {
    // window.onload = function() {

      // Get the user's location using Geolocation API
    navigator.geolocation.getCurrentPosition(function(position) {


      var latitudeFromGeocoder = position.coords.latitude
      var longitudeFromGeocoder = position.coords.longitude

      // Testing, uncomment these to manually change the location for testing, this will update the marker for the current user and their most recent location instance at the same time
      var latitudeFromGeocoder = (Math.random() * 180) - 90;
      var longitudeFromGeocoder = (Math.random() * 360) - 180;
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
      const customMarkerImageSrc = friendsById[friendLocation.user_id].avatar ? friendsById[friendLocation.user_id].avatar : '/assets/backpack-icon-large-1.png';
      var popup = new mapboxgl.Popup().setHTML(`<p style="font-size: 36px;">${friendsById[friendLocation.user_id].first_name}</p>`);

      const customMarker = new mapboxgl.Marker({
        element: document.createElement('div'),
        anchor: 'left' // Adjust the anchor point as needed
      })
      customMarker.setLngLat(friendCoords).addTo(map);

      // Set the custom image as the marker icon
      customMarker.getElement().innerHTML = `<img src="${customMarkerImageSrc}" alt="Custom Marker" class="marker ${customMarkerImageSrc.includes("backpack-icon-large") ? "" : "avatar-marker"}" >`;

      var popup = new mapboxgl.Popup().setHTML(popupHTML(friendLocation, friendsById));
      customMarker.setPopup(popup);
    });
  })
});

function lastSeen(location) {
  const locationDate = new Date(location.datetime)
  const currentTime = new Date()
  const timeDifferenceMs = currentTime - locationDate;
  const secondsAgo = Math.floor(timeDifferenceMs / 1000);
  const minutesAgo = Math.floor(secondsAgo / 60);
  const hoursAgo = Math.floor(minutesAgo / 60);
  const daysAgo = Math.floor(hoursAgo / 24);

  console.log("hellooo:", timeDifferenceMs)

  if (daysAgo > 0) {
    result = `${daysAgo} day(s) ago`;
  } else if (hoursAgo > 0) {
    result = `${hoursAgo} hour(s) ago`;
  } else if (minutesAgo > 0) {
    result = `${minutesAgo} minute(s) ago`;
  } else {
    result = `${secondsAgo} second(s) ago`;
  }

  return result
}

function popupHTML(friendLocation, friendsById) {
  const username = friendsById[friendLocation.user_id].username
  const firstName = friendsById[friendLocation.user_id].first_name
  const lastSeenString = lastSeen(friendLocation)
  const whatsAppNumber = friendsById[friendLocation.user_id].whatsapp_number
  const instagramAccount = friendsById[friendLocation.user_id].instagram_account

  if (whatsAppNumber && instagramAccount) {
    return `<p style="font-size: 24px; margin: 5px;">${firstName}</p><span style="display: flex;">(<a href="https://instagram.com/${username}" target="blank"><p style="margin: 0;">@${username}</p></a>)</span><p style="margin: 0;">${whatsAppNumber}</p><p style="margin: 0px;">${lastSeenString}</p>`
  } else if (whatsAppNumber) {
    return`<p style="font-size: 24px; margin: 5px;">${firstName}</p><span style="display: flex;">(<p style="margin: 0;">@${username}</p>)</span><p style="margin: 0;">${whatsAppNumber}</p><p style="margin: 0px;">${lastSeenString}</p>`
  } else if (instagramAccount) {
    return `<p style="font-size: 24px; margin: 5px;">${firstName}</p><span style="display: flex;">(<a href="https://instagram.com/${username}" target="blank"><p style="margin: 0;">@${username}</p></a>)</span><p style="margin: 0px;">${lastSeenString}</p>`
  } else {
    return `<p style="font-size: 24px; margin: 5px;">${firstName}</p><span style="display: flex;">(<p style="margin: 0;">@${username}</p>)</span><p style="margin: 0px;">${lastSeenString}</p>`
  }
}
