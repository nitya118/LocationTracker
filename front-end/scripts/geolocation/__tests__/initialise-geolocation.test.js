import { initialiseCallersGeolocation } from '../initialise-geolocation';
import { LocalStorageMock } from '../__mocks__/mock-local-storage';
import {
	mockNavigatorGeolocationResolve,
	mockNavigatorGeolocationReject,
} from '../__mocks__/mock-navigator-geolocation';

Object.defineProperty(window, 'localStorage', {
	value: new LocalStorageMock(),
});

describe('Initialise Callers Current Geolocation', () => {
	afterEach(() => {
		window.localStorage.clear();
		global.navigator.geolocation = null;
	});

	it('goes to location services page if navigator geolocation is not allowed', () => {
		const mockUrl = './location-services-info.html';

		Object.defineProperty(window, 'location', {
			value: {
				href: 'http://test.com',
			},
			writable: true,
		});

		initialiseCallersGeolocation();

		expect(window.location.href).toEqual(mockUrl);
	});

	it('get users current latitude and longitude and saves it to local storage', async () => {
		global.navigator.geolocation = mockNavigatorGeolocationResolve;

		const result = await initialiseCallersGeolocation();
		const expectedResult = {
			latitude: 50.1,
			longitude: 50.1,
		};
		const storedGeolocation = window.localStorage.getItem('callersGeolocation');

		expect(result).toEqual(expectedResult);
		expect(result).toEqual(JSON.parse(storedGeolocation));
	});

	it('handles navigator geolocation error', () => {
		global.navigator.geolocation = mockNavigatorGeolocationReject;

		const result = initialiseCallersGeolocation();

		expect(result).rejects.toEqual(
			'Geolocation is not supported by this browser.'
		);
	});
});
