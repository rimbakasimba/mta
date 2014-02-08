using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public abstract class ACustomer
    {
        public string Name { get; protected set; }
        public Card Card { get; set; }
    }

    public class Customer : ACustomer
    {
        // Everything fulfilled in abstract class
        public Customer(string name, string cardNumber)
        {
            base.Name = name;
            base.Card = new Card(cardNumber);
        }

    }

    public class StarBucksCustomer
    {
        private Customer cust;
        public int Age { get; private set; }

        public StarBucksCustomer(string name, int age, string cardNumber)
        {
            this.cust = new Customer(name, cardNumber);
            this.Age = age;
        }

        public StarBucksCustomer(Customer cust, int age)   : this(cust.Name, age, cust.Card.Number)
        {
            // Customer can have some balance as well
            if (cust.Card.Balance != 0)
            {
                this.Card.ReloadCard(cust.Card.Balance);
            }
        }

        public Card Card { get { return this.cust.Card; } private set { } }
    }

    public class Test
    {
        public float CreateStarbucksCustomerWithBaseCust()
        {
            Customer c = new Customer("rimba", "343545345");
            c.Card.ReloadCard(200);

            StarBucksCustomer s = new StarBucksCustomer(c, 32);
            s.Card.ReloadCard(150);

            return s.Card.Balance;      // must show  350
        }
    }
}
