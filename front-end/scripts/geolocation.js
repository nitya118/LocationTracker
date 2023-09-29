export const getUsersGeoLocation = () => {
	return new Promise((resolve, reject) => {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(
				(position) => {
					const latitude = position.coords.latitude;
					const longitude = position.coords.longitude;
					resolve({ latitude, longitude });
				},
				(error) => {
					console.log('Error getting geolocation:', error);
					reject(error);
				}
			);
		} else {
			latitude = 0;
			longitude = 0;
			console.log('Geolocation is not supported by this browser.');
			reject('Geolocation is not supported');
		}
	});
};
