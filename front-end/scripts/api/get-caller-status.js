async function apiCall(url) {
	const response = await fetch(url, {
		method: 'GET',
		mode: 'cors',
	});

	return response.status;
}

async function checkStatus(url) {
	const status = await apiCall(url);

	if (status === 200) {
		window.location.href = './pages/share-location.html';
	} else if (status === 404) {
		window.location.href = './pages/not-found.html';
	}
}

async function main() {
	localStorage.clear();

	// Get caller id from url and store
	const callerId = new URL(location.href).searchParams.get('id');
	localStorage.setItem('callerId', callerId);

	const apiUrl = `https://u4hdqm5uvkvdthwk54elxlkpbi0wpdef.lambda-url.eu-west-1.on.aws?id=${callerId}`;

	checkStatus(apiUrl);
}

main();
