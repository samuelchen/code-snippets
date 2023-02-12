/*
  Chrome snippet to crawl projects
*/

var counter = 0; 
var domain = window.location.host;


function getData(){

    var ul = document.querySelector("#subgroups_and_projects")
    var rows = ul.querySelectorAll("li");
    
    for (var row of rows) {
        var div = row.querySelector("div.namespace-title");
        if (!div) {
            break;
        }
        var a = div.querySelectorAll("a");
        
        var isSubOrg = false;

        if (row.getAttribute("itemprop") == "subOrganization") {
            isSubOrg = true;
            console.log( a[0].title + " | is sub org");
        }
        

        counter += 1

        var names = a[0].title.split("/");
        var repo = "git@" + domain + ":"+ names[0].trim() + "/" + names[1].trim() + "/" + names[2].trim() + ".git";
        var desc = row.querySelector("div.description");
        if (desc) {
            desc = desc.querySelector("p").innerText;
        } else {
            desc = "";
        }
        
        console.log( a[0].title + " | " + repo  + " | " + desc);
    }

}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
  while (true) {

    getData();
    
    var next = document.querySelector("a.next-page-item");
    if(next){
        next.click();
        await sleep(1500);
    } else {
        break;
    }
  }

  console.log("total: " + counter);
}

// getData();

main();



