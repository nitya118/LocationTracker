using System.Reflection;
using System.Text.RegularExpressions;

namespace LocationTracker.Utils
{
    public static class Utility
    {


        /// <summary>
        /// Given a mobile number , check to see whether it's in a valid uk network format
        /// </summary>
        /// <param name="phoneNumber"></param>
        /// <returns></returns>
        public static bool IsValidateUKMobileNumber(string mobile)
        {
            // Remove all non-digit characters from the phone number string
            string digitsOnly = Regex.Replace(mobile, @"\D", "");

            // Check if the resulting string has either 11 or 13 digits
            if (digitsOnly.Length != 11 && digitsOnly.Length != 12)
            {
                return false;
            }

            // Check if the string starts with '07' and is followed by 9 more digits,
            // or if it starts with '+4407' followed by 9 more digits
            if (Regex.IsMatch(digitsOnly, @"^(07\d{9}|447\d{9})$"))
            {
                return true;
            }

            return false;
        }



        /// <summary>
        /// Given a uk mobile number convert it into the international format 
        /// starting with +44
        /// </summary>
        /// <param name="mobile"></param>
        /// <returns></returns>
        public static string ConvertUkMobileToInternational(string mobile)
        {
            string digitsOnly = Regex.Replace(mobile, @"\D", "");

            if (digitsOnly.StartsWith("07"))
            {
                return "+44" + digitsOnly.Substring(1);
            }
            else
            {
                return "+" + digitsOnly;
            }
        }



    }

}
