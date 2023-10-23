import {
    Grid,
    html,h
} from "https://unpkg.com/gridjs?module";


const confirmationDialog = (title, text, confirmCallback) => {

    const dialog = new bootstrap.Modal(document.getElementById('confirmation'), {
        keyboard: false
    });

    const confirmationText = document.getElementById("confirmationText");
    const confirmationTitle = document.getElementById("confirmationTitle");
    const btnYes = document.getElementById("btnYes");

    confirmationText.innerText = text;
    confirmationTitle.innerText = title;


    btnYes.onclick =() => {
        if (typeof confirmCallback === 'function') {
            confirmCallback();
            dialog.hide();
        }
    };

    return {
        hide: () => {
            dialog.hide();
        },
        show: async () => {
            dialog.show();
        }
    }

}




let editItem = (cell, row) => {

    return h('a', {
        className: '',
        onClick: () => {
            sub.load(row.cells[0].data, row.cells[2].data, row.cells[3].data , row.cells[4].data)
        }
    }, 'Edit');

};

let deleteItem = (cell, row) => {

    return h('a', {
        className: '',
        onClick: () => {
           let confirmer = confirmationDialog("Delete user", `Do you want to delete ${ row.cells[0].data} ?`, () => {

               sub.delete(row.cells[0].data);
               
            })

            confirmer.show();
        },

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


const globalSettingsManager =async () => {

    const chkLogin = document.getElementById("chkGlobalLogin");
    const chkSms = document.getElementById("chkGlobalSms");

    const dvAlertLogin = document.getElementById("dvLoginAlert")
    const dvAlertSms = document.getElementById("dvSmsAlert")

    //load settings
    let getUrl = "/User/GetUser?username=GlobalUser";


    let response = await fetch(getUrl, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    });

    let user = await response.json();

    console.log(user);

    chkLogin.checked = user.canLogin;
    chkSms.checked = user.canSendSms;

    if (chkLogin.checked) {
        dvAlertLogin.classList.add("d-none");

    } else {
        dvAlertLogin.classList.remove("d-none");
    }

    if (chkSms.checked) {
        dvAlertSms.classList.add("d-none");
    } else {
        dvAlertSms.classList.remove("d-none");
    }


    let fnChange = async () => {
        if (chkLogin.checked) {
            dvAlertLogin.classList.add("d-none");

        } else {
            dvAlertLogin.classList.remove("d-none");
        }

        if (chkSms.checked) {
            dvAlertSms.classList.add("d-none");
        } else {
            dvAlertSms.classList.remove("d-none");
        }

        //save settings
        let postUrl = "/User/SaveGlobalSettings";

        let response = await fetch(postUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `login=${chkLogin.checked}&sms=${chkSms.checked}`

        })

    };

    chkLogin.onchange = fnChange;
    chkSms.onchange = fnChange;


};








const submitter = (updateCallback) => {

    
    const closeButton = document.getElementsByClassName("btn-close")[0];

    const _username = document.getElementById("username");
    const _isSupervisor = document.getElementById("is-supervisor");
    const _canLogin = document.getElementById("can-login");
    const _canSendSMS = document.getElementById("can-send-sms");

    const addUserForm = new bootstrap.Modal(document.getElementById('addUserModal'), {
        keyboard: false
    });

    const submitButton = document.getElementById("submit");


    closeButton.onclick = () => {
        addUserForm.hide();
    }


    _username.onchange = () => _username.classList.remove("invalid");



    const getData = async () => {
        let dataUrl = '/User/GetUsers';

        let response = await fetch(dataUrl, { method: 'get' });

        let data = await response.json();

        if (typeof updateCallback === 'function') {
            updateCallback(data);
        }
    };


    const deleteUser = async (username) => {
        let deleteUrl ="/User/DeleteUser"

        let response = await fetch(deleteUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `username=${username}`

        });
    };



     submitButton.onclick =async  () => {
        //do validations

         if (!_username.checkValidity()) {
             _username.classList.add("invalid");
             return;
         }

        const postUrl = "/User/SaveUser";

        let response =await fetch(postUrl,
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

        
         if (response.status === 200) {
             addUserForm.hide();
             await getData();
         }

        
        
    }


 


    return {
        show: () => {
            _username.value = "";
            _canLogin.checked = false;
            _canSendSMS.checked = false;
            _isSupervisor.checked = false;
            addUserForm.show();
        },
         refresh:async () => {

             await getData();

        },
        load: (userName, isSupervisor, canLogin, canSendSms) => {
            _username.value = userName;
            _canLogin.checked = canLogin;
            _canSendSMS.checked = canSendSms;
            _isSupervisor.checked = isSupervisor;
            addUserForm.show();
        },
        delete:async (username) => {

            await deleteUser(username);

            await getData();
        }
    }

}


let sub = submitter((data) => {
    let newConf = Object.assign({}, grid.config);

    newConf.data = data;

    grid.config.plugin.remove("search");

    grid.updateConfig(newConf).forceRender();
});

await sub.refresh();


const addUser = document.getElementById("addUser");

addUser.onclick = () => {
   sub.load("",false,true,true);
}


await globalSettingsManager();


