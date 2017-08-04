using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace aspTestTask
{
    /// <summary>
    /// Сводное описание для testService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Чтобы разрешить вызывать веб-службу из скрипта с помощью ASP.NET AJAX, раскомментируйте следующую строку. 
    [System.Web.Script.Services.ScriptService]
    public class testService : WebService
    {

        [WebMethod]
        public void addPerson(string surname, string name, string patronymic)
        {
            Person newPerson = new Person(surname, name, patronymic);
            try
            {
                newPerson.saveInDB();
            }
            catch (HttpException ex)
            {
                Context.Response.StatusCode = 500;
                Context.Response.StatusDescription = ex.Message;
            }
        }

        [WebMethod]
        public List<Person> searchPerson(string surname, string name, string patronymic)
        {
            List<Person> result = null;
            try
            {
                result = Person.getPersons(surname, name, patronymic);
            }
            catch (HttpException ex)
            {
                Context.Response.StatusCode = ex.ErrorCode;
                Context.Response.StatusDescription = ex.Message;
            }

            return result;
        }
    }
}
