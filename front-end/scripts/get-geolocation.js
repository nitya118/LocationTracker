import { initialiseUsersGeolocation } from './initialise-geolocation.js';

export const getUsersGeoLocation = async () => {
	console.log('getting geolocation');
	let storedGeolocation = localStorage.getItem('usersGeolocation');
	let usersGeolocation;

	if (!storedGeolocation) {
		initialiseUsersGeolocation().then(async () => {
			storedGeolocation = localStorage.getItem('usersGeolocation');
			usersGeolocation = JSON.parse(storedGeolocation);
			console.log('geting geo:', usersGeolocation);
		});
	} else {
		storedGeolocation = localStorage.getItem('usersGeolocation');
		usersGeolocation = JSON.parse(storedGeolocation);

		console.log('geo exists:', usersGeolocation);
	}

	return usersGeolocation;
};
