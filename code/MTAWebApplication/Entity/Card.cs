using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class Card
    {
        public string Number { get; private set; }
        public float Balance { get; private set; }

        public Card(string number)
        {
            this.Number = number;
            this.Balance =0.0F;
        }

        public bool ReloadCard(float amount)
        {
            this.Balance += amount;
            // some biz rules to be processed here
            return true;
        }
    }
}
