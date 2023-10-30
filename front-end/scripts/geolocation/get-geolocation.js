import { initialiseCallersGeolocation } from './initialise-geolocation.js';

export const getCallersGeoLocation = async () => {
	let storedGeolocation = localStorage.getItem('callersGeolocation');
	let callersGeolocation;

	if (!storedGeolocation) {
		try {
			await initialiseCallersGeolocation();
		} catch (error) {
			console.error(error);
		}

		storedGeolocation = localStorage.getItem('callersGeolocation');
		callersGeolocation = JSON.parse(storedGeolocation);

		console.log("User's coordinates: ", callersGeolocation);
		return callersGeolocation;
	} else {
		callersGeolocation = JSON.parse(storedGeolocation);

		console.log("User's stored coordinates: ", callersGeolocation);
		return callersGeolocation;
	}
};
