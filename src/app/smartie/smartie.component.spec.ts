import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SmartieComponent } from './smartie.component';

describe('SmartieComponent', () => {
  let component: SmartieComponent;
  let fixture: ComponentFixture<SmartieComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SmartieComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SmartieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
