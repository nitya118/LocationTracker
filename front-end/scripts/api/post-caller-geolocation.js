async function apiCall(location) {
	const callerId = localStorage.getItem('callerId');

	const apiUrl =
		'https://u4hdqm5uvkvdthwk54elxlkpbi0wpdef.lambda-url.eu-west-1.on.aws';

	const data = {
		id: callerId,
		lat: location.latitude,
		lon: location.longitude,
	};

	const response = await fetch(apiUrl, {
		method: 'POST',
		mode: 'cors',
		body: JSON.stringify(data),
	});

	return response.status;
}

export async function shareGeolocation() {
	const callersGeolocation = JSON.parse(
		localStorage.getItem('callersGeolocation')
	);
	const status = await apiCall(callersGeolocation);

	if (status === 200) {
		localStorage.clear();
		window.location.href = './successful-submit.html';
	} else if (status === 404) {
		localStorage.clear();
		window.location.href = './already-submitted.html';
	}
}
