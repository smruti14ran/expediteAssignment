import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CartService } from '../cart.service';
import { FormBuilder } from '@angular/forms';
import { Observable } from 'rxjs';

interface LineItem {
  unitPrice: number;
  quantity: number;
  lineItemId: string;
  description: string | null;
}

interface Quote {
  status: string;
  quoteName: string;
  quoteLineItems: LineItem[];
  quoteId: string;
}

interface Opportunity {
  stageName: string;
  quotes: Quote[];
  opportunityName: string;
  opportunityId: string;
  closeDate: string;
}

interface ApiResponse {
  status: string;
  data: Opportunity[];
}

@Component({
  selector: 'app-smartie',
  templateUrl: './smartie.component.html',
  styleUrls: ['./smartie.component.css']
})
export class SmartieComponent implements OnInit {
  response: any;
  itemLists:any = [];
  showItem:boolean = false;
  itemName:any;

  constructor(
    private http: HttpClient,
    private cartService: CartService,
    private formBuilder: FormBuilder,
  ) {}

  ngOnInit(): void {
    const accountId = '001J2000007Hp5cIAC';

    // Call the getData API
    this.getDataFromApi(accountId).subscribe((data) => {
      this.response = JSON.parse(data); // Cast the result as ApiResponse
      console.log('API Response:', this.response);
    });
  }

  // Function to get data from the Salesforce REST API
  getDataFromApi(accountId: string): Observable<any> {
    const url = `https://mindful-panda-7c23g3-dev-ed.trailblaze.my.salesforce-sites.com/services/apexrest/getData?accountId=${accountId}`;
    return this.http.get(url);
  }

  itemList(itemList:any, name:any){
    console.log(itemList)
    this.itemName = name;
    this.showItem = true;
    this.itemLists = itemList;
  }
  
}
