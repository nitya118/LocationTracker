
import {
    Grid,
    html, h, PluginPosition, useSelector, useConfig, useState
} from "https://unpkg.com/gridjs?module";



export const mapManager =async (mapSettings,modalEle,titleEle) => {

    let lat = 51.584856;
    let long = 0.059955;

    const authHelper = await amazonLocationAuthHelper.withIdentityPoolId(mapSettings.PoolId);

    const map = new maplibregl.Map({
        container: "map",
        center: [long, lat],
        zoom: 10,
        style: `https://maps.geo.${mapSettings.Region}.amazonaws.com/maps/v0/maps/${mapSettings.MapName}/style-descriptor`,
        ...authHelper.getMapAuthenticationOptions(),
    });
    map.addControl(new maplibregl.NavigationControl(), "top-left");

    const marker = new maplibregl.Marker()
        .setLngLat([long, lat])
        .addTo(map);


    return {
        displayMap: (lat, long, title) => {

            map.setCenter([long, lat]);
            marker.setLngLat([long, lat]);;
            marker.addTo(map);

            let mapModal = new bootstrap.Modal(modalEle, {
                keyboard: false
            });
            titleEle.innerText = title;
            mapModal.show();
        }
    }
}


export const submitLocationReport = async (mobileEle,nameEle) => {

   

    mobileEle.onchange = () => { mobileEle.classList.remove("invalid") };
    nameEle.onchange = () => { nameEle.classList.remove("invalid") }

    if (!mobileEle.checkValidity()) {
        mobileEle.classList.add("invalid");
        return;
    }

    if (!nameEle.checkValidity()) {
        nameEle.classList.add("invalid");
        return;
    }


    //save settings
    let postUrl = "/LocationReports/CreateLocationReport";

    let response = await fetch(postUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `mobile=${mobileEle.value}&name=${nameEle.value}`

    });

    mobileEle.value = "";
    nameEle.value = "";

    console.log(response);


}




export const gridManager = async (wrapperElement, btnTest,mapDisplayObj) => {


    let locationFormatter = (cell, row) => {


        if (row.cells[2].data == "3") {
            return h('div', { "className": "flex-parent-element" }, [
                h("a", {
                    "href": "#",
                    "className": "flex-child-element"
                }, cell),
                h("button", {
                    className: "btn btn-primary",
                    onclick: () => {
                        mapDisplayObj.displayMap(row.cells[0].data, row.cells[1].data, `${row.cells[3].data}  ${row.cells[4].data}`);
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
            { id: "name", name: "Name", width: "15%" },
            { id: "mobile", name: "Mobile", width: "10%" },
            { id: "createdBy", name: "Created By", width: "15%" },
            { id: "createdDateTime", name: "Timestamp", width: "10%" },
            { id: "statusString", name: "Status", width: "15%" },
            { id: "eastingsNorthings", name: "Location", width: "35%", formatter: locationFormatter },

        ],
        data: []
    }).render(wrapperElement);



    const getData = async () => {

        let dataUrl = '/LocationReports/GetLocationReports';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        return data;
    }



    const refreshGrid = async () => {
        grid.config.plugin.remove("search");

        grid.config.plugin.remove("pagination");

        let newConf = Object.assign({}, grid.config);

        newConf.data = await getData();

        grid.updateConfig(newConf).forceRender();

    }



    btnTest.onclick = async function (e) {
       await refreshGrid()
    };

    


    setInterval(() => {

        grid.config.plugin.remove("search");

        grid.config.plugin.remove("pagination");

        let newConf = Object.assign({}, grid.config);

        let promise = getData();

        promise.then((data) => {
            newConf.data = data;

            grid.updateConfig(newConf).forceRender();

        });

    }, 15000)

    await refreshGrid();

}

