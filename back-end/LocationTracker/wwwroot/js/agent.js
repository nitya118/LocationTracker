
import {
    Grid,
    html, h, PluginPosition, useSelector, useConfig, useState
} from "https://unpkg.com/gridjs?module";

let wrapper = document.getElementById("wrapper");
let btnTest = document.getElementById("btnTest");


const identityPoolId = "eu-west-1:478a32d0-58df-414f-a4f2-e2e58c300742"
const mapName = "quick-start-using-cognito-example"
const region = "eu-west-1";
let lat = 51.584856 ;
let long = 0.059955;
const authHelper = await amazonLocationAuthHelper.withIdentityPoolId(identityPoolId);
const map = new maplibregl.Map({
    container: "map",
    center: [long, lat],
    zoom: 10,
    style: `https://maps.geo.${region}.amazonaws.com/maps/v0/maps/${mapName}/style-descriptor`,
    ...authHelper.getMapAuthenticationOptions(),
});
map.addControl(new maplibregl.NavigationControl(), "top-left");

const marker = new maplibregl.Marker()
    .setLngLat([long, lat])
    .addTo(map);






export const displayMap =  (lat,long) => {

    map.setCenter([long, lat]);
    marker.setLngLat([long, lat]);;
    marker.addTo(map);

    let mapModal = new bootstrap.Modal(document.getElementById('mapModal'), {
        keyboard: false
    });

    mapModal.show();
}




export const gridManager = async (wrapperElement, btnTest) => {


    let statusFormatter = (cell, row) => {

        if (cell == "3") {

            return h('button', {
                className: '',
                onClick: () => {
                   // alert(`Show Map "${row.cells[0].data}" "${row.cells[1].data}"`);
                    displayMap(0,0);
                }
            }, 'View Map');

            
        }

        if (cell == "1") {
            return "SMS Sent"
        }
    }



    let grid = new gridjs.Grid({
        search: true,
        sort: true,
        resizable: true,
        columns: [
            { id: "Id", name: "Id", hidden: true },
            { id: "name", name: "Name" },
            { id: "mobile", name: "Mobile" },
            { id: "createdBy", name: "Created By" },
            { id: "createdDateTimeUTC", name: "Created Date" },
            { id: "status", name: "Status", formatter: statusFormatter },
        ],
        data: [
            ["1", "John", "0712730623", "alice@contoso.com", "12-Oct 13:45", "3"],

        ]
    }).render(wrapperElement);


 




    btnTest.onclick = async function (e) {

        let dataUrl = '/Home/GetLocationReports';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        grid.config.plugin.remove("search");

        grid.config.plugin.remove("pagination");

        let newConf = Object.assign({}, grid.config);

        newConf.data = data;

        grid.updateConfig(newConf).forceRender();
    };
}



await gridManager(wrapper,btnTest);