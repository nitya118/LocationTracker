export const initialiseCallersGeolocation = () => {
	return new Promise((resolve, reject) => {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(
				(position) => {
					const callersGeolocation = {
						latitude: position.coords.latitude,
						longitude: position.coords.longitude,
					};
					localStorage.setItem(
						'callersGeolocation',
						JSON.stringify(callersGeolocation)
					);
					resolve({ callersGeolocation });
				},
				(error) => {
					console.log('Error getting geolocation:', error);
					reject(error);
					window.location.href = './successful-submit.html';
				}
			);
		} else {
			const callersGeolocation = {
				latitude: 0,
				longitude: 0,
			};

			localStorage.setItem(
				'callersGeolocation',
				JSON.stringify(callersGeolocation)
			);
			console.log('Geolocation is not supported by this browser.');
			reject('Geolocation is not supported');
		}
	});
};
