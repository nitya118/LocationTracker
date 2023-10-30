using LocationTrackerLib.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace LocationTrackerLib.Tests.Integration
{
    public class ParameterStoreTests
    {
        [Fact]
        public async  Task we_can_retrieve_param_store_values()
        {
            var sut=new ParameterStoreService();

           var ret= await sut.GetParameterStoreModel();

            Assert.NotNull(ret);

            Assert.True(ret.MapName.Length > 0);
        }
    }
}
