using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessRules
{
    public interface IBizRule
    {
        bool Process(params object[] args);
    }

    public class BizRuleException : ApplicationException
    {
        public string ArgName { get; private set; }
        public string ArgIssue { get; set; }
        public Exception RuleException { get; set; }

        public BizRuleException(string argName)
        {
            this.ArgName = argName;
        }
    }

    /// <summary>
    /// Specifies that a customer of "minAge" is required to reload a balance of "amountThreshold"
    /// Actual age and amount being reloaded are parameters
    /// 
    /// customers >= 18 only can reload over 25$   
    /// </summary>
    public class ReloadAgeRestriction : IBizRule
    {
        private int minAge;
        private float amountThreshhold;

        public ReloadAgeRestriction(int minAge, float amountThreshhold)
        {
            this.minAge = minAge;
            this.amountThreshhold = amountThreshhold;
        }

        public bool Process(params object[] args)
        {
            int ageOfCustomer;            
            float amountToReload;

            BizRuleException exp = null;            

            if (2 > args.Count()) {
                exp = new BizRuleException("General");
                exp.ArgIssue = "No arguments found, 1st arg must be age, 2nd must be amount";
            }               
            if (!int.TryParse(args[0].ToString(), out ageOfCustomer))
            {
                exp = new BizRuleException("Age of Customer");
                exp.ArgIssue = "Not an integer";
            }
            if (!float.TryParse(args[1].ToString(), out amountToReload))
            {
                exp = new BizRuleException("Amount to reload");
                exp.ArgIssue = "Not a number";
            }
            if (null != exp)
                throw exp;

            return (!((ageOfCustomer < this.minAge) && (amountToReload > this.amountThreshhold)));   
        }
    }
}
