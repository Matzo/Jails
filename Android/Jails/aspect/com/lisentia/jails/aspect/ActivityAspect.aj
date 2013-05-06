package com.lisentia.jails.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;

import android.app.Activity;
import android.os.Bundle;

import com.lisentia.jails.Jails;

public aspect ActivityAspect {
	
	
	/**
	 * @param thisJoinPoint
	 * @see Activity
	 * @see Bundle
	 */
	@After("execution(void Activity+.onCreate(Bundle))")
	public void beforeOnCreate(JoinPoint thisJoinPoint) {
		Activity target = (Activity) thisJoinPoint.getTarget();
		Jails jails = new Jails();
		jails.adjustViews(target);
	}
}
