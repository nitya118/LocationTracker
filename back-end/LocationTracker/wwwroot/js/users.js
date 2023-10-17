import {
    Grid,
    html,h
} from "https://unpkg.com/gridjs?module";



let editItem = (cell, row) => {

    return h('a', {
        className: '',
        onClick: () => {
            sub.load(row.cells[0].data, row.cells[1].data, row.cells[2].data, row.cells[3].data)
        }
    }, 'Edit');

};

let deleteItem = (cell, row) => {

    return h('a', {
        className: '',
        onClick: () => alert(`Show Map "${row.cells[0].data}" "${row.cells[1].data}"`)
    }, 'Delete');

};






let grid = new gridjs.Grid({
    search: true,
    sort: true,
    resizable: true,
    width:"100%",
    columns: [
        { id: "userName", name: "User Name", hidden: false,"width":"20%" },
        { id: "isSystem", name: "Is System", hidden: true },
        { id: "isSupervisor", name: "Type", formatter: (cell) => cell ? "Supervisor" : "Agent", "width": "20%" },
        { id: "canLogin", name: "Login", formatter: (cell) => cell ? "Enabled" : "Disabled", "width": "15%" },
        { id: "canSendSms", name: "SMS", formatter: (cell) => cell ? "Enabled" : "Disabled", "width": "15%" },
        { id: "Edit", formatter: editItem, "width": "15%" },
        { id: "Delete", formatter: deleteItem, "width": "15%" },
    ],
    data: []
}).render(wrapper);


const globalSettingsManager = () => {



};





const submitter = (updateCallback) => {

    const wrapper = document.getElementById("wrapper");
    const overlay = document.getElementById("overlay")
    const dataEntryForm = document.getElementById("dataentry");
    const closeButton = document.getElementsByClassName("user-close")[0];

    const _username = document.getElementById("username");
    const _isSupervisor = document.getElementById("is-supervisor");
    const _canLogin = document.getElementById("can-login");
    const _canSendSMS = document.getElementById("can-send-sms");

    const submitButton = document.getElementById("submit");


    closeButton.onclick = () => {
        overlay.style.display = "none";
    }


    _username.onchange = () => _username.classList.remove("invalid");


   


     submitButton.onclick = () => {
        //do validations

         if (!_username.checkValidity()) {
             _username.classList.add("invalid");
             return;
         }

        const postUrl = "/User/SaveUser";

        let response = fetch(postUrl,
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(  {
                    UserName: _username.value,
                    IsSystem:false,
                    IsSupervisor: _isSupervisor.checked,
                    CanSendSms: _canSendSMS.checked,
                    CanLogin: _canLogin.checked
                })

            }
        );

         response.then((resp) => {
             console.log(resp);
             if (resp.status===200) {
                 overlay.style.display = "none";
             }
         })
        
    }


    const getData =async () => {
        let dataUrl = '/User/GetUsers';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        if (typeof updateCallback === 'function') {
            updateCallback(data);
        }
    };


    return {
        show: () => {
            _username.value = "";
            _canLogin.checked = false;
            _canSendSMS.checked = false;
            _isSupervisor.checked = false;
            overlay.style.display = "block";
        },
         refresh:async () => {

             await getData();

        },
        load: (userName, isSupervisor, canLogin, canSendSms) => {
            _username.value = userName;
            _canLogin.checked = canLogin;
            _canSendSMS.checked = canSendSms;
            _isSupervisor.checked = isSupervisor;
            overlay.style.display = "block";
        }
    }

}


let sub = submitter((data) => {
    let newConf = Object.assign({}, grid.config);

    newConf.data = data;

    console.log(data);

    grid.config.plugin.remove("search");

    grid.updateConfig(newConf).forceRender();
});

await sub.refresh();


const addUser = document.getElementById("addUser");

addUser.onclick = () => {
   sub.load("",false,true,true);
}


globalSetter();
