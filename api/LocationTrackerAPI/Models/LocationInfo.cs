using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using ThirdParty.Json.LitJson;

namespace LocationTrackerAPI.Models
{
    public class LocationInfo
    {
        [JsonPropertyName("id")]
        public string Id { get; set; }
        [JsonPropertyName("lat")]
        public double Lat { get;set; }
        [JsonPropertyName("lon")]
        public double Lon { get; set; }
    }
}
