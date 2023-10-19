import { initialiseCallersGeolocation } from './initialise-geolocation.js';

export const getCallersGeoLocation = async () => {
	return new Promise((resolve, reject) => {
		let storedGeolocation = localStorage.getItem('callersGeolocation');
		let callersGeolocation;

		if (!storedGeolocation) {
			initialiseCallersGeolocation().then(async () => {
				storedGeolocation = localStorage.getItem('callersGeolocation');
				callersGeolocation = JSON.parse(storedGeolocation);

				console.log("User's coordinates: ", callersGeolocation);
				resolve(callersGeolocation);
			});
		} else {
			callersGeolocation = JSON.parse(storedGeolocation);

			console.log("User's coordinates: ", callersGeolocation);
			resolve(callersGeolocation);
		}
	});
};
