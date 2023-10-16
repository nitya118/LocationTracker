
import {
    Grid,
    html, h, PluginPosition, useSelector, useConfig, useState
} from "https://unpkg.com/gridjs?module";

let wrapper = document.getElementById("wrapper");
let btnClick = document.getElementById("btnClick");


export const agentGrid = async (wrapperElement, btnTest) => {

   

    function MyPlugin() {
        //const [total, setTotal] = useState(0);

        //const data = useSelector((state) => state.data);

        //useEffect(() => {

        //    console.log(data);

        //}, [data])
       
        


       
        return h('select', { id: "timeRange" },
            [
                h('option', {}, "All"),
                h('option', {}, "Last 15m"),
                h('option', {}, "Last 30m"),
                h('option', {}, "Last 1h"),
                h('option', {}, "Last 3h"),
                h('option', {}, "Last 6h"),
                h('option', {}, "Last 12h")
            ]);




       
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
        position: PluginPosition.Header,
    });


    grid.on("rowClick", (row, cell) => {


        const selectedRows = document.querySelectorAll("tr.selected");

        selectedRows.forEach((r) => {
            r.classList.remove("selected");
        });

      
        let selectedRow = row.srcElement.parentElement;

        selectedRow.classList.add("selected");

        console.log(selectedRow);

    });
    




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



await agentGrid(wrapper,btnClick);