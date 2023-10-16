//  Returns 200 and changes status to 3.

const okData = {
	id: 'lana-test-200',
	lat: 88,
	lon: 88,
};
// lat: 35.630247101947,
// lon: 139.789580218396,
const notFoundData = {
	id: 'lana-test-404',
	lat: 33.33,
	lon: 99.99,
};

const invalidIdData = {
	id: '000-abc',
	lat: 33.33,
	lon: 99.99,
};

async function apiCall(url, data) {
	const response = await fetch(url, {
		method: 'POST',
		mode: 'cors',
		body: JSON.stringify(data),
	});

	return response;
}

async function main() {
	console.log('sending request');
	const response = await apiCall(url, okData);
	console.log('response: ', response);
}
main();
