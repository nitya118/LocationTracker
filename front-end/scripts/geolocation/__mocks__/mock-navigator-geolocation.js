export const mockNavigatorGeolocationResolve = {
	getCurrentPosition: jest.fn().mockImplementationOnce((success) =>
		Promise.resolve(
			success({
				coords: {
					latitude: 50.1,
					longitude: 50.1,
				},
			})
		)
	),
};

export const mockNavigatorGeolocationReject = {
	getCurrentPosition: jest.fn().mockImplementationOnce((error) =>
		Promise.reject(
			error({
				code: 1,
				message: 'GeoLocation Error',
			})
		)
	),
};
