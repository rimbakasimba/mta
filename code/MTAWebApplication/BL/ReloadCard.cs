using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BusinessRules;
using Entity;

namespace BL
{           
    public interface IReloadCard
    {
        float ReloadCard(string cardNumber, float amount);
    }

    public class CoreCard : IReloadCard
    {
        // simulated datastore
        List<Entity.Card> cards;

        public CoreCard()
        {
            this.cards = new List<Entity.Card>();
            this.cards.Add(new Card("123456"));
        }

        //Base function, the decorators will enhance this by adding functionality on top of this
        public float ReloadCard(string cardNumber, float amount)
        {                                                                     
            var cardToReload = this.cards.Find(c => c.Number == cardNumber);
            if (null != cardToReload)
            {
                cardToReload.ReloadCard(amount);
                return cardToReload.Balance;
            }
            else
            {
                return -1;
            }
        }
    }     

    //MTA using Decorator
    public class StarBucksCard : IReloadCard
    {
        private IReloadCard card;

        public StarBucksCard(IReloadCard card)
        {
            this.card = card;
        }

        /// <summary>
        /// Implement biz rule that only amount less than 100$ will be loadable
        /// </summary>
        /// <param name="cardNumber"></param>
        /// <param name="amount"></param>
        /// <returns></returns>
        public float ReloadCard(string cardNumber, float amount)
        {
            if (amount <= 100)
            {
                return this.card.ReloadCard(cardNumber, amount);
            }
            else
                throw new Exception("Cannot load more than 100$");
        }
    }
}
