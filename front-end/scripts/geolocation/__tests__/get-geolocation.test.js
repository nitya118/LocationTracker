import { getCallersGeoLocation } from '../get-geolocation';
import { initialiseCallersGeolocation } from '../initialise-geolocation';
import { LocalStorageMock } from '../__mocks__/mock-local-storage';
import { mockNavigatorGeolocationResolve } from '../__mocks__/mock-navigator-geolocation';

jest.mock('../initialise-geolocation');

Object.defineProperty(window, 'localStorage', {
	value: new LocalStorageMock(),
});

describe('Get Callers Geolocation', () => {
	afterEach(() => {
		window.localStorage.clear();
		global.navigator.geolocation = null;
		jest.clearAllMocks();
	});

	it('retrieves callers geolocation from local storage if it exists', async () => {
		const mockGeolocation = {
			latitude: 1,
			longitude: 1,
		};

		window.localStorage.setItem(
			'callersGeolocation',
			JSON.stringify(mockGeolocation)
		);

		const result = await getCallersGeoLocation();

		expect(result).toEqual(mockGeolocation);
	});

	it('calls function to initialise users geolocation if not in local storage', async () => {
		global.navigator.geolocation = mockNavigatorGeolocationResolve;

		await getCallersGeoLocation();

		expect(initialiseCallersGeolocation).toHaveBeenCalledTimes(1);
	});

	// it('logs an error if an error is caught', async () => {
	// 	initialiseCallersGeolocation.mockImplementation(() =>
	// 		console.error('Geolocation is not supported by this browser.')
	// 	);
	// 	console.error = jest.fn();

	// 	global.navigator.geolocation = mockNavigatorGeolocationReject;

	// 	await getCallersGeoLocation();

	// 	expect(console.error).toHaveBeenCalled();
	// 	expect(console.error.mock.calls[0][0]).toContain(
	// 		'Geolocation is not supported by this browser.'
	// 	);
	// });
});
