using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Data.SqlClient;

namespace aspTestTask
{
    public class Person
    {
        private static SqlConnection sqlConnect = new SqlConnection(WebConfigurationManager.ConnectionStrings["connStringDb"].ConnectionString);
        private static SqlCommand sqlCmd = new SqlCommand("", sqlConnect);

        public string surname { get; set; }
        public string name { get; set; }
        public string patronymic { get; set; }

        public Person(string surname, string name, string patronymic)
        {
            this.surname = surname;
            this.name = name;
            this.patronymic = patronymic;
        }
        public Person(){ }
        
        /// <summary>
        /// Добавляет в БД запись об этой персоне
        /// </summary>
        public void saveInDB()
        {
            sqlCmd.Parameters.Clear();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "addPerson";

            sqlCmd.Parameters.AddWithValue("@surname", this.surname);
            sqlCmd.Parameters.AddWithValue("@name", this.name);
            sqlCmd.Parameters.AddWithValue("@patronymic", this.patronymic);

            try
            {
                sqlConnect.Open();
                sqlCmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                //Number >= 50000 для пользовательских ошибок SQL, не встроенных
                if (ex.Number >= 50000)
                {
                    //Если ошибка пользовательская, то клиенту отправляем текст ошибки
                    throw new HttpException(500, ex.Message);
                }
                else
                {   
                    throw new HttpException(500, "Internal Server Error");
                }
            }
            catch (Exception)
            {
                throw new HttpException(500, "Internal Server Error");
            }
            finally
            {
                sqlConnect.Close();
            }

        }

        /// <summary>
        /// Возвращает лист персон, удовлетворяющих фильтру по фамилии, имени и отчетсву
        /// </summary>
        public static List<Person> getPersons(string surname, string name, string patronymic)
        {
            List<Person> result = new List<Person>();

            sqlCmd.Parameters.Clear();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "searchPerson";

            sqlCmd.Parameters.AddWithValue("@surname", surname);
            sqlCmd.Parameters.AddWithValue("@name", name);
            sqlCmd.Parameters.AddWithValue("@patronymic", patronymic);

            try
            {
                sqlConnect.Open();
                SqlDataReader reader = sqlCmd.ExecuteReader();
                if (reader.HasRows)
                {
                    string newSurname;
                    string newName;
                    string newPatronymic;

                    while (reader.Read())
                    {
                        newSurname = reader.GetString(0);
                        newName = reader.GetString(1);
                        newPatronymic = reader.GetString(2);

                        result.Add(new Person(newSurname, newName, newPatronymic));
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
            finally
            {
                sqlConnect.Close();
            }

            return result;
        }
    }
}