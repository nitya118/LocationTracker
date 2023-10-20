
import {
    Grid,
    html, h, PluginPosition, useSelector, useConfig, useState
} from "https://unpkg.com/gridjs?module";

const wrapper = document.getElementById("wrapper");
const btnTest = document.getElementById("btnTest");
const btnSubmit = document.getElementById("btnSubmit");


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

 const displayMap =  (lat,long,title) => {

    map.setCenter([long, lat]);
    marker.setLngLat([long, lat]);;
    marker.addTo(map);

    let mapModal = new bootstrap.Modal(document.getElementById('mapModal'), {
        keyboard: false
    });

    let mapTitle = document.getElementById("mapTitle");

    mapTitle.innerText = title;

    mapModal.show();
}


const submitter = async () => {

    const mobile = document.getElementById("txtMobile");
    const name = document.getElementById("txtName");
   

    mobile.onchange = () => { mobile.classList.remove("invalid") };
    name.onchange = () => { name.classList.remove("invalid") }

    if (!mobile.checkValidity()) {
        mobile.classList.add("invalid");
        return;
    }

    if (!name.checkValidity()) {
        name.classList.add("invalid");
        return;
    }


    //save settings
    let postUrl = "/Home/CreateLocationReport";

    let response = await fetch(postUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `mobile=${mobile.value}&name=${name.value}`

    });

    mobile.value = "";
    name.value = "";

    console.log(response);


}




 const gridManager = async (wrapperElement, btnTest) => {


    let locationFormatter = (cell, row) => {


        if (row.cells[2].data == "3") {
            return h('div', { "className":"flex-parent-element"}, [
                h("a", {
                    "href": "#",
                    "className":"flex-child-element"
                }, cell),
                h("button", {
                    className:"btn btn-primary",
                    onclick: () => {
                        displayMap(row.cells[0].data, row.cells[1].data, `${row.cells[3].data}  ${row.cells[4].data}`);
                    }
                }, "View Map")
            ])
        }

        
    }



    let grid = new gridjs.Grid({
        search: true,
        sort: true,
        resizable: true,
        columns: [
            { id: "lat", name: "lat", hidden: true },
            { id: "long", name: "long", hidden: true },
            { id: "status", name: "status", hidden: true },
            { id: "name", name: "Name", width:"15%" },
            { id: "mobile", name: "Mobile", width: "10%" },
            { id: "createdBy", name: "Created By", width: "15%" },
            { id: "createdDateTime", name: "Timestamp", width: "10%" },
            { id: "statusString", name: "Status", width: "15%" },
            { id: "eastingsNorthings", name: "Location", width: "35%", formatter: locationFormatter },
           
        ],
        data: []
    }).render(wrapperElement);


 
    const getData= async ()=>{

        let dataUrl = '/Home/GetLocationReports';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        return data;
    }



    btnTest.onclick = async function (e) {

        grid.config.plugin.remove("search");

        grid.config.plugin.remove("pagination");

        let newConf = Object.assign({}, grid.config);

        newConf.data =await getData();

        grid.updateConfig(newConf).forceRender();
     };

     btnSubmit.onclick = async (e) => {
         await submitter();

         grid.config.plugin.remove("search");

         grid.config.plugin.remove("pagination");

         let newConf = Object.assign({}, grid.config);

         newConf.data = await getData();

         grid.updateConfig(newConf).forceRender();
     }


     setInterval(() => {

         grid.config.plugin.remove("search");

         grid.config.plugin.remove("pagination");

         let newConf = Object.assign({}, grid.config);

         let promise = getData();

         promise.then((data) => {
             newConf.data = data;

             grid.updateConfig(newConf).forceRender();

         });

     },15000)

}





await gridManager(wrapper,btnTest);