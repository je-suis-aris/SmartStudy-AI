function validateLogin() {
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();

    if (email === "" || password === "") {
        alert("Veuillez remplir email et mot de passe.");
        return false;
    }

    return true;
}

function confirmDelete() {
    return confirm("Voulez-vous vraiment supprimer cet élément ?");
}

$(document).ready(function () {
    $("#searchInput").on("keyup", function () {
        const value = $(this).val().toLowerCase();

        $(".searchable").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});