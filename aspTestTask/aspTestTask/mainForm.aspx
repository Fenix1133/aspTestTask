<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mainForm.aspx.cs" Inherits="aspTestTask.mainForm" EnableEventValidation="false"%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Поиск и добавление</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/extension.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
        <form id="form">
            <div id="main">
                <div class="row form-inline main-first-row">
                    <label for="usr" class="col-md-1 col-md-offset-4 main-lable">Фамилия:</label>
                    <input type="text" class="col-md-3" id="txtSurname" onkeydown="return textValidate(event);"/>
                </div>

                <div class="row form-inline main-row">
                    <label for="usr" class="col-md-1 col-md-offset-4 main-lable">Имя:</label>
                    <input type="text" class="col-md-3" id="txtName" onkeydown="return textValidate(event);"/>
                </div>

                <div class="row form-inline main-row">
                    <label for="usr" class="col-md-1 col-md-offset-4 main-lable">Отчетсво:</label>
                    <input type="text" class="col-md-3" id="txtPatronymic" onkeydown="return textValidate(event);"/>
                </div>

                <button type="button" class="btn btn-primary col-md-4 col-md-offset-4 main-button" id="btnAddPerson">Создать</button>
                <button type="button" class="btn btn-primary col-md-4 col-md-offset-4 main-button" id="btnSearchPerson">Найти</button>
            </div>
            
            <div id="searchResult" hidden>
                <button type="button" class="btn btn-primary" id="btnBack">
                    Назад
                </button>
                <table class="table-bordered table-cell-padding search-result-table">
                    <thead>
                        <tr style="height:40px">
                            <th class="search-result-table-head">Фамилия</th>
                            <th class="search-result-table-head">Имя</th>
                            <th class="search-result-table-head">Отчетсво</th>
                        </tr>
                    </thead>
                     <tbody id="table"></tbody>
                </table>
            </div>
        </form>

      <script src="js/jquery-3.2.1.js"></script>
      <script type="text/javascript">
            
          $(document).ready(
              function () {
                  $("#btnAddPerson").click(addNewPerson)

                  $("#btnSearchPerson").click(function () {
                      searchPerson();
                      $(main).hide('slow');
                      $(searchResult).show('slow');
                  })

                  $("#btnBack").click(function () {
                      $(main).show('slow');
                      $(searchResult).hide('slow');
                  })
              }
              )

            function textValidate(event)
            {
                var key = event.keyCode;
                return ((key >= 65 && key <= 90) || key == 8 || key == 16 || key == 37 || key == 39 || key == 46);
            }

            function addNewPerson() {
                var srn = $('#txtSurname').val().trim();
                var n = $('#txtName').val().trim();
                var p = $('#txtPatronymic').val().trim();

                $.ajax({
                    url: 'testService.asmx/addPerson',
                    data: { surname: upFirstLetter(srn), name: upFirstLetter(n), patronymic: upFirstLetter(p) },
                    method: 'post',
                    datatype: 'json',
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status + ' ' + thrownError);
                    }
                })

                $('#txtSurname').val("");
                $('#txtName').val("");
                $('#txtPatronymic').val("");
            }
            function searchPerson() {
                var srn = $('#txtSurname').val().trim();
                var n = $('#txtName').val().trim();
                var p = $('#txtPatronymic').val().trim();

                $.ajax({
                    url: 'testService.asmx/searchPerson',
                    data: {surname: srn, name: n, patronymic: p },
                    method: 'post',
                    datatype: 'xml',
                    success: fillTable,
                    error: function (xhr, ajaxOptions, thrownError) {
                        alert(xhr.status + ' ' + thrownError);
                    }
                })
               
            }
            function fillTable(data) {
                $("#table tr").remove();
                var xml = $(data).find('Person')
                var html;
                xml.each(function () {
                    var sn = $(this).find('surname').text();
                    var n = $(this).find('name').text();
                    var p = $(this).find('patronymic').text();

                    html = '<tr><td>' + sn + '</td><td>' + n + '</td><td>' + p + '</td></tr>';
                    $(table).append(html);
                })
            }

            function upFirstLetter(str) {
                if (str.length > 0) {
                    return str[0].toUpperCase() + str.slice(1);
                }
                else {
                    return '';
                }
            }
      </script>
  </body>
</html>
