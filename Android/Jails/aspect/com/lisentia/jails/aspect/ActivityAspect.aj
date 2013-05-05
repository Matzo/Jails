package com.lisentia.jails.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Before;

import com.lisentia.jails.Jails;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public aspect ActivityAspect {
	
	
	/**
	 * @param thisJoinPoint
	 * @see Activity
	 * @see Bundle
	 */
	@Before("execution(void Activity+.onCreate(Bundle))")
	public void beforeOnCreate(JoinPoint thisJoinPoint) {
		Activity target = (Activity) thisJoinPoint.getTarget();
		Jails jails = new Jails();
		jails.adjustViews(target);
	}
}
