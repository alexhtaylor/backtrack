
var map
var dropdownButton = document.getElementById('friends-dropdown-button')
var dropdownContent = document.querySelector('.friends-dropdown-content')

dropdownButton.addEventListener('click', () => {
  dropdownContent.classList.toggle('active')
})

window.onload = function() {

  // Setting the loading position of the map
  if (navigator.geolocation) {

    // document.getElementById('note').textContent = `navigator.geolocation is true`;
    console.log("using geolocation")

    navigator.geolocation.getCurrentPosition(function(position) {
      var newLongitude = position.coords.longitude
      var newLatitude = position.coords.latitude

      // document.getElementById('latitude').textContent = `latitude from geo: ${newLatitude}`;
      // document.getElementById('longitude').textContent = `longitude from geo: ${newLongitude}`;

      map = L.map('map').setView([newLatitude, newLongitude], 100)
      L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Map data &copy Esri'
      }).addTo(map)

      addMarkersToMap(newLatitude, newLongitude, friendLocations)
      map.setView([newLatitude, newLongitude], 13)
    })
  } else {
      // document.getElementById('latitude').textContent = `latitude from ip, being used: ${latitudeFromIp}`;
      // document.getElementById('longitude').textContent = `longitude from ip, being used: ${longitudeFromIp}`;
    console.log(`using ip address, latitude is ${latitudeFromIp}`)

      map = L.map('map').setView([latitudeFromIp, longitudeFromIp], 100)
      L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Map data &copy Esri'
      }).addTo(map)

      addMarkersToMap(map)
      map.setView([latitudeFromIp, longitudeFromIp], 13)
  }

  function addMarkersToMap(given_latitude, given_longitude, friendLocations) {
    console.log('friend locations:',friendLocations)
    console.log('lat and long given', given_latitude, given_longitude)
    friendLocations.forEach(function(l) {
        var redIcon = L.icon({
            iconUrl: "https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png",
            shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
            iconSize: [25, 41],
            iconAnchor: [12, 41],
            popupAnchor: [1, -34],
            shadowSize: [41, 41]
        });
        L.marker([l.latitude, l.longitude], { icon: redIcon }).addTo(map)
            .bindPopup(`<p>${friendsById[l.user_id].first_name} (<a href="https://www.instagram.com/${friendsById[l.user_id].username}" target="_blank">@${friendsById[l.user_id].username}</a>)</p>`).openPopup();
    });

    if (given_latitude && given_longitude) {
        // adding marker for your own location (not taken from database)
        L.marker([given_latitude, given_longitude], {icon: L.icon({
            iconUrl: "https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-blue.png",
            shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
            iconSize: [25, 41],
            iconAnchor: [12, 41],
            popupAnchor: [1, -34],
            shadowSize: [41, 41]
        })}).addTo(map)
        .bindPopup("You").openPopup();
    }
  }

  // navigator.geolocation.getCurrentPosition(function(position) {
  //   var latitude = position.coords.latitude
  //   var longitude = position.coords.longitude

  //   // send the location data to the server-side.
  //   $.ajax({
  //     url: '/locations',
  //     type: 'GET',
  //     dataType: 'json',
  //     data: { latitude: latitude, longitude: longitude },
  //     success: function(data) {
  //       // handle the server-side response
  //     }
  //   })
  // })
}
