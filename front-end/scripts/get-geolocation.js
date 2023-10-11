import { initialiseUsersGeolocation } from './initialise-geolocation.js';

export const getUsersGeoLocation = async () => {
	return new Promise((resolve, reject) => {
		let storedGeolocation = localStorage.getItem('usersGeolocation');
		let usersGeolocation;

		if (!storedGeolocation) {
			initialiseUsersGeolocation().then(async () => {
				storedGeolocation = localStorage.getItem('usersGeolocation');
				usersGeolocation = JSON.parse(storedGeolocation);

				console.log('Users intial coordinates: ', usersGeolocation);
				resolve(usersGeolocation);
			});
		} else {
			usersGeolocation = JSON.parse(storedGeolocation);

			console.log('Users intial coordinates: ', usersGeolocation);
			resolve(usersGeolocation);
		}
	});
};
