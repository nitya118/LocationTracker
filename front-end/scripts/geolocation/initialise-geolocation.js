export const initialiseCallersGeolocation = async () => {
	return new Promise((resolve, reject) => {
		try {
			if (navigator.geolocation) {
				let callersGeolocation;
				navigator.geolocation.getCurrentPosition((position) => {
					callersGeolocation = {
						latitude: position.coords.latitude,
						longitude: position.coords.longitude,
					};
					localStorage.setItem(
						'callersGeolocation',
						JSON.stringify(callersGeolocation)
					);
					resolve(callersGeolocation);
				});
			} else {
				window.location.href = './location-services-info.html';
			}
		} catch (error) {
			reject('Geolocation is not supported by this browser.');
		}
	});
};
