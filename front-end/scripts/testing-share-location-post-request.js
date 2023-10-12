const url =
	'https://u4hdqm5uvkvdthwk54elxlkpbi0wpdef.lambda-url.eu-west-1.on.aws';

const okData = {
	id: 'lana-test-200',
	lat: 35.630247101947,
	lon: 139.789580218396,
};

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
		headers: {
			Accept: 'application/json',
			'Content-Type': 'application/json',
		},
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
