
import {
    Grid,
    html,h
} from "https://unpkg.com/gridjs?module";

let wrapper = document.getElementById("wrapper");
let btnClick = document.getElementById("btnClick");


export const agentGrid = async (wrapperElement, btnTest) => {

   

    function MyPlugin() {
        return h('h1', {}, 'Hello World!');
    }


    let statusFormatter = (cell, row) => {

        if (cell == "3") {

            return h('button', {
                className: 'py-2 mb-4 px-4 border rounded-md text-white bg-blue-600',
                onClick: () => alert(`Show Map "${row.cells[0].data}" "${row.cells[1].data}"`)
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
        pagination: true,
        limit:10,
        columns: [
            { id: "Id", name: "Id", hidden: true },
            { id: "name", name: "Name" },
            { id: "mobile", name: "Mobile" },
            { id: "createdBy", name: "Created By" },
            { id: "createdDateTimeUTC", name: "Created Date" },
            { id: "status", name: "Status", formatter: statusFormatter },
        ],
        data: [
            ["1", "John", "0712730623", "alice@contoso.com", "12-Oct 13:45", "Sent"],

        ]
    }).render(wrapperElement);


    grid.plugin.add({
        id: 'myplugin',
        component: MyPlugin,
        position: 'header',
    });


   



    btnTest.onclick = async function (e) {

        let dataUrl = '/Home/GetLocationReports';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        grid.config.plugin.remove("search");

        let newConf = Object.assign({}, grid.config);

        newConf.data = data;

        grid.updateConfig(newConf).forceRender();
    };
}



await agentGrid(wrapper,btnClick);