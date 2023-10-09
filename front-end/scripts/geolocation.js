export const getUsersGeoLocation = () => {
	return new Promise((resolve, reject) => {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(
				(position) => {
					const latitude = position.coords.latitude;
					const longitude = position.coords.longitude;
					localStorage.setItem('userLatitude', latitude);
					localStorage.setItem('userLongitude', longitude);
					resolve({ latitude, longitude });
				},
				(error) => {
					console.log('Error getting geolocation:', error);
					reject(error);
				}
			);
		} else {
			localStorage.setItem('userLatitude', 0);
			localStorage.setItem('userLongitude', 0);
			console.log('Geolocation is not supported by this browser.');
			reject('Geolocation is not supported');
		}
	});
};
