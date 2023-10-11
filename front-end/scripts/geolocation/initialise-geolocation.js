export const initialiseUsersGeolocation = () => {
	return new Promise((resolve, reject) => {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(
				(position) => {
					const usersGeolocation = {
						latitude: position.coords.latitude,
						longitude: position.coords.longitude,
					};
					// Temporary solution: save user's coords to local storage
					localStorage.setItem(
						'usersGeolocation',
						JSON.stringify(usersGeolocation)
					);
					resolve({ usersGeolocation });
				},
				(error) => {
					console.log('Error getting geolocation:', error);
					reject(error);
				}
			);
		} else {
			const usersGeolocation = {
				latitude: 0,
				longitude: 0,
			};

			localStorage.setItem(
				'usersGeolocation',
				JSON.stringify(usersGeolocation)
			);
			console.log('Geolocation is not supported by this browser.');
			reject('Geolocation is not supported');
		}
	});
};
