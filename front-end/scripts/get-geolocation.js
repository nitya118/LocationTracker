import { initialiseUsersGeolocation } from './initialise-geolocation.js';
let usersGeolocation;

export const getUsersGeoLocation = async () => {
	console.log('getting geolocation');
	usersGeolocation = localStorage.getItem('usersGeolocation');

	if (!usersGeolocation) {
		initialiseUsersGeolocation().then(async () => {
			usersGeolocation = localStorage.getItem('usersGeolocation');
			console.log('geting geo:', JSON.parse(usersGeolocation));
		});
	}

	// return usersGeolocation;
};

getUsersGeoLocation();
